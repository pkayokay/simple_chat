import { Head, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();
  const flashMessage = page.props.flash.info || page.props.flash.error;
  if (flashMessage) {
    alert(flashMessage);
  }

  return (
    <div className="p-5">
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <main>{children}</main>
    </div>
  );
}
