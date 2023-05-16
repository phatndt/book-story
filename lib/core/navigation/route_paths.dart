class RoutePaths {
  static const splash = '/';
  static const welcome = '/welcome';
  static const logIn = '/login';
  static const signUp = '$logIn/register';
  static const verifyEmail = '/verified';
  static const forgot = '/login/forgot';
  static const main = '/mainScreen';

  static const profile = '/profile';
  static const changePassword = '$profile/password';

  static const home = '/home';
  static const addBook = '$home/add_book';
  static const bookDetail = '$home/bookDetail';
  static const previewBook = '$home/preview_book';
  static const contributeBook = '/contributeBook';
  static const readBookFile = '$bookDetail/readBookFile';
  static const editBook = '$home/editBook';

  static const bookShelf = '/bookShelf';
  static const addBookShelf = '$bookShelf/addBookShelf';
  static const searchBookShelf = '$bookShelf/searchBookShelf';
  static const bookShelfDetail = '$bookShelf/bookShelfDetail';

  static const changeInformation = '/change_information';

  static const share = '/share';
  
  static const chatMessage = '/chatMessage';

  static const post = '/post';
  static const addPost = post + '/add';
  static const myPost = post + '/myPost';
  static const editPost = post + '/editPost';
  static const postDetail = post + '/detail';
}
