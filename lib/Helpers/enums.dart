enum PageType {
  editPaymentMethod,
  selectPaymentMethod,
}

enum WalletType {
  addFunds,
  createWallet,
  loadAndPay,
}

enum PaymentType {
  creditCard,
  giftCard,
  applePay,
}

enum MembershipPlan {
  annual,
  monthly,
}

enum SubscriptionStatus {
  active,
  paused,
  canceled,
  failed,
  none,
}

SubscriptionStatus fromString(String status) {
  switch (status.toUpperCase()) {
    case 'ACTIVE':
      return SubscriptionStatus.active;
    case 'PAUSED':
      return SubscriptionStatus.paused;
    case 'CANCELED':
      return SubscriptionStatus.canceled;
    case 'FAILED':
      return SubscriptionStatus.failed;
    case 'NONE':
      return SubscriptionStatus.none;
    default:
      return SubscriptionStatus.none;
  }
}
