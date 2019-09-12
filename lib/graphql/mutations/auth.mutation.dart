String tokenLogin = """
  mutation TokenLogin {
    tokenLogin {
      id
      email
      token
    }
  }
""";

String login = """
  mutation Login(\$email: String!, \$password: String!) {
    login(input: {email: \$email, password: \$password}) {
      id
      email
      token
    }
  }
""";