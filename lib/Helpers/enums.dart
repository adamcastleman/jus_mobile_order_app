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
  daily,
}

enum SubscriptionStatus {
  active,
  paused,
  canceled,
  failed,
  pendingCancel,
  none,
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  bool get isActive {
    return this == SubscriptionStatus.active ||
        this == SubscriptionStatus.pendingCancel;
  }

  bool get isNotActive {
    return !isActive;
  }
}

SubscriptionStatus fromString(String status) {
  switch (status.toUpperCase()) {
    case 'ACTIVE':
      return SubscriptionStatus.active;
    case 'PENDING-CANCEL':
      return SubscriptionStatus.pendingCancel;
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
