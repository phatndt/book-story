abstract class AppEnvironment {
  static setupEnv(Environment env) {
    switch (env) {
      case Environment.dev:
        break;
      case Environment.prod:
        break;
    }
  }
}

enum Environment { dev, prod }
