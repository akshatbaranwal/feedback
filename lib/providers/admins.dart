import '../import.dart';

class Admin {
  final int adminid;
  final String email;

  Admin({
    @required this.adminid,
    @required this.email,
  });
}

class AdminData with ChangeNotifier {
  final connection;
  AdminData(this.connection);

  var _emailList = [];
  Admin _data;

  List<String> get emailList {
    return [..._emailList];
  }

  Admin get data {
    return Admin(
      adminid: _data.adminid,
      email: _data.email,
    );
  }

  Future<void> fetchEmails() async {
    try {
      final response = await connection.query('''
      select email from admin
      ''');
      if (response.isNotEmpty) {
        final loadedEmails = [];
        response.forEach((element) {
          loadedEmails.add(element[0]);
        });
        _emailList = loadedEmails;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> login({
    @required email,
    @required password,
  }) async {
    try {
      final response = await connection.query(
        '''
    select adminid, email
    from admin
    where email = @email
    and password = crypt(@password, password)
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      if (response.isNotEmpty) {
        _data = Admin(
          adminid: response[0][0],
          email: response[0][1],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> register({
    @required email,
    @required password,
  }) async {
    try {
      final response = await connection.query(
        '''
    insert into admin (email, password)
    values (@email, crypt(@password, gen_salt('bf')))
    returning *
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      if (response.isNotEmpty) {
        _data = Admin(
          adminid: response[0][0],
          email: response[0][1],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> edit({
    @required id,
    @required password,
  }) async {
    try {
      await connection.query(
        '''
      update admin
      set password = crypt(@password, gen_salt('bf'))
      where id = @id
      ''',
        substitutionValues: {
          'id': id,
          'password': password,
        },
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
