<script lang="ts">
	import "../app.css"
	import { injected } from "@wagmi/connectors"
	import {
		http,
		createConfig,
		getConnections,
		getConnectors,
		connect,
		getAccount,
		disconnect,
		watchAccount
	} from "@wagmi/core"
	import {
		mainnet,
		zkSync,
		zkSyncSepoliaTestnet,
		anvil,
		zkSyncInMemoryNode
	} from "@wagmi/core/chains"
	import { onMount } from "svelte"
	import { Moon } from "svelte-loading-spinners"

	export const config = createConfig({
		chains: [mainnet, zkSync, zkSyncSepoliaTestnet, anvil, zkSyncInMemoryNode],
		connectors: [injected()],
		transports: {
			[mainnet.id]: http(),
			[zkSync.id]: http(),
			[zkSyncSepoliaTestnet.id]: http(),
			[anvil.id]: http(),
			[zkSyncInMemoryNode.id]: http()
		}
	})

	let connected = false
	let loading = true

	onMount(async () => {
		const account = await getAccount(config)
		console.log(account)
	})

	const checkConnected = watchAccount(config, {
		onChange(data) {
			console.log("Account changed!", data)
			setConnected()
		}
	})
	checkConnected()

	async function setConnected() {
		const connectors = await getConnectors(config)
		if (connectors.length > 0) {
			const recentConnector =
				JSON.parse(localStorage.getItem("wagmi.recentConnectorId") || "") || undefined
			if (recentConnector) {
				for (let connector of connectors) {
					if (connector.id === recentConnector) {
						const accounts = await connector.getAccounts()
						if (accounts.length > 0) {
							connected = true
							break
						}
					}
				}
				if (!connected) {
					localStorage.removeItem("wagmi.recentConnectorId")
					await disconnect(config)
				}
			}
		} else {
			console.log("No connectors found")
		}
		loading = false
	}

	// async function isConnected() {
	// 	const account = await getAccount(config)
	// 	console.log(account)
	// 	return account.status == "connected"
	// }

	async function handleConnect() {
		await connect(config, { connector: injected() })
		const account = await getAccount(config)
		console.log(account)
		await setConnected()
	}
</script>

<div>
	{#if loading}
		<Moon size="40" color="#FF3E00" unit="px" duration="1s" />
	{:else if connected}
		<div>Connected</div>
	{:else}
		<button class="rounded border border-blue-500" id="connectButton" on:click={handleConnect}>
			Connect
		</button>
	{/if}
</div>
