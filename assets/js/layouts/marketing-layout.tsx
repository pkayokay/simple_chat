import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ pageTitle: string }>();

  return (
    <div>
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <div className="mb-4 space-x-4">
        <Link className="text-blue-600" href="/">
          Home
        </Link>{" "}
        <Link className="text-blue-600" href="/pricing">
          Pricing
        </Link>
        <a className="text-blue-600" href="/app">
          App
        </a>
      </div>
      <main>{children}</main>
    </div>
  );
}
