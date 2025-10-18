import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();
  const flashMessage = page.props.flash.info || page.props.flash.error;
  if (flashMessage) {
    alert(flashMessage);
  }

  return (
    <div>
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <div>
        <Link href="/">Home</Link>
        <Link href="/rooms">Rooms</Link>
      </div>
      <main>{children}</main>
    </div>
  );
}
