import 'package:postgres/postgres.dart';

PostgreSQLConnection connection;

Future<void> initConnection() async {
  connection = PostgreSQLConnection(
    'ec2-3-234-85-177.compute-1.amazonaws.com',
    5432,
    'd228faaghhgu4',
    username: 'lqkqmhyttllxgb',
    password:
        'f8057d66531c5d47201e4453f33e7346b473bfed1e3ebf1049a1c1fb616c8853',
    useSSL: true,
  );
  await connection.open();
}
