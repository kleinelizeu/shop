class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "O endereço de e-mail já está sendo usado por outra conta.",
    "OPERATION_NOT_ALLOWED":
        "O login de senha está desativado para este projeto.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum. Tente mais tarde.",
    "EMAIL_NOT_FOUND": "Não há registro de usuário correspondente a este email",
    "INVALID_PASSWORD": "A senha é inválida ou o usuário não possui uma senha.",
    "USER_DISABLED":
        "A conta do usuário foi desabilitada por um administrador.",
  };
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return "Houve um erro inesperado tente mais tarde";
    }
  }
}
