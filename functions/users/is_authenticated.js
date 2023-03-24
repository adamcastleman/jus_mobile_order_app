function isAuthenticated(context) {
  return context.auth !== null;
}

module.exports = isAuthenticated;