import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();
  const flashMessage = page.props.flash.info || page.props.flash.error;
  if (flashMessage) {
    alert(flashMessage);
  }

  return (
    <div className="p-7">
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <Link href="/">Back to Marketing page</Link>
      <div className="mb-4 space-x-4">
        <Link href="/app">Dashboard</Link> <Link href="/app/settings">Settings</Link>
      </div>
      <main>{children}</main>
    </div>
  );
}
