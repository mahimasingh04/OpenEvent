'use client'

import { ConnectButton } from '@rainbow-me/rainbowkit'

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold mb-8">Welcome to OpenEvent</h1>
      <p className="text-xl mb-8 text-center max-w-2xl">
        A decentralized platform for creating and participating in events using web3 identity primitives
      </p>
      <ConnectButton />
    </div>
  )
}
