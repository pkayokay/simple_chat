import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();
  const { flash, pageTitle } = page.props;
  const flashMessage = flash.info || flash.error;

  if (flashMessage) {
    alert(flashMessage);
  }

  return (
    <div>
      <Head>
        <title>{pageTitle}</title>
      </Head>
      <div>
        <Link href="/">Home</Link>
        <Link href="/about">About</Link>
        <Link href="/rooms">Rooms</Link>
      </div>
      <main>{children}</main>
    </div>
  );
}
