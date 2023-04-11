class Endpoints {
  Endpoints._();

  // base url
  // static const String baseUrl =
  //     "https://lionfish-app-aur8e.ondigitalocean.app/v1";
  static const String baseUrl =
      "https://lionfish-app-aur8e.ondigitalocean.app/v1";

  // receiveTimeout
  static const int receiveTimeout = 10000;

  // connectTimeout
  static const int connectionTimeout = 10000;

  static const String login = '/authentication/login';

  static const String register = '/authentication/register';

  static const String email = '/authentication/email';

  static const String getUserByUserId = '/authentication/getUserByUserId';

  static const String sendVerificationEmailWhenRegistering =
      '/authentication/user/sendEmail';
  static const String verifyRegistrationUser =
      "/authentication/verification/getVerificationByUser";
  static const String setVerificationUser =
      "/authentication/user/verification/set";
  static const String getAllUser =
      "/authentication/user/getAll";
      

  //can define other
  static const String uploadBook = '/book/create';

  static const String editBook = '/book/update';

  static const String deleteBook = '/book/delete';

  static const String getBookByUserId = '/book/read/user';

  static const String changePassword = '/profile/changePassword';

  //post
  static const String addPost = '/post/create';

  static const String getAllPost = '/post/read/list';

  static const String getMyPost = '/post/read/user';
  static const String deletePost = '/post/delete';
  static const String getPostByPostId = '/post/read/post';
  static const String getUser = '/authentication/getUser';

  //user
  static const String changeAvatarPath = '/authentication/user/changeAvatarPath';
  static const String changeUsername = '/authentication/user/changeUsername';
  static const String changeAdress = '/authentication/user/changeAddress';

  //contribution book
  static const String uploadContributionBook = '/contributionBook/create';

  static const String getVerifiedContributionBook = '/';

  static const String getContributionBookByISBNBarcode =
      '/contributionBook/isbnBarcode';
  static const String getContributionBookByNormalBarcode =
      '/contributionBook/normalBarcode';

  //comment
  static const String createComment = '/post/comment/create';
  static const String getCommentByPost = '/post/comment/read/post';
}
