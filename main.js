// Wires every product's "Pay with Venmo" link to a properly-encoded Venmo URL.
// Reads data-venmo, data-amount, data-note off each .pay-link element.
// Venmo deep-link format: https://venmo.com/?txn=pay&recipients=<user>&amount=<n>&note=<text>
// On phones with Venmo installed, iOS/Android hand off to the app with the fields prefilled.

(function wirePayLinks() {
  const links = document.querySelectorAll(".pay-link");

  for (const link of links) {
    const { venmo, amount, note } = link.dataset;
    if (!venmo || !amount) continue;

    const params = new URLSearchParams({
      txn: "pay",
      recipients: venmo,
      amount: String(amount),
      note: note || "",
    });

    link.href = `https://venmo.com/?${params.toString()}`;
  }
})();
