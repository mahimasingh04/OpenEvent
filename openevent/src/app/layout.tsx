import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Web3Provider } from "@/components/web3/Web3Provider";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "OpenEvent - Decentralized Event Platform",
  description: "A platform for creating and participating in events using web3 identity primitives",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Web3Provider>
          <main className="min-h-screen bg-gray-50">
            {children}
          </main>
        </Web3Provider>
      </body>
    </html>
  );
}
