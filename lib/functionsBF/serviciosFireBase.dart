import 'package:cloud_firestore/cloud_firestore.dart';

//Instancia FireBase
FirebaseFirestore db = FirebaseFirestore.instance;
//

//------------------------Agregar Usuario-----------------------------------
Future<void> addUser(String user) async {
  //Funcion de generar un usuario nuevo conforme al identificador en String del usuario
  //de la session actual
  //Inicialización de subcolección
  //Es una inicialización de campos vacios solo para que se genere el usuario sin campos
  final datosTransactions = <String, dynamic>{
    "monto": 0,
    "fecha": DateTime.now(),
    "concepto": "newUser",
    "tipo": "none", //Ingreso o Egreso
  };

  final datosAssum = <String, dynamic>{
    "expense": 0,
    "name": "",
  };
  //Subcoleccion de transacciones
  //!!!!!!!!!!!!!!CAMBIAR EL USUARIO AL ACTIVO
  final refTransactions =
      db.collection('users').doc(user).collection('transactions').doc();

  refTransactions.set(datosTransactions);

  //Subcoleccion de Supuestos
  final refSupues =
      db.collection('users').doc(user).collection('assumption').doc();
  refSupues.set(datosAssum);

  //Generación de campo SALDO, este cambiara con cada ingreso y egreso
  final refUsuario = db.collection('users').doc(user);
  refUsuario.set({"saldo": 0});
}

//------------------------Agregar Transaccion-----------------------------------
Future<void> addTransaction(
    String user, double monto, String concepto, int tipo) async {
  ///Agrega una transaccion conforme al monto (ingresarlo en valor absoluto), sera positivo
  ///negativo conforme al tipo ya sea 1 (+monto) o 0 (-monto)
  ///el identificador en String del usuario actual
  ///ingresar concepto.
  final transaccion = <String, dynamic>{
    "monto": tipo == 1 ? monto : -monto,
    "fecha": DateTime.now(),
    "concepto": concepto,
    "tipo": tipo,
  };
  //Demo es el usuario cambialo por el user de autentication
  db.collection("users").doc(user).collection('transactions').add(transaccion);

  //Actualizamos el saldo
  db.collection("users").doc(user).update(
    {"saldo": FieldValue.increment(transaccion["monto"])},
  );
}

//------------------------Consultas-----------------------------------
//Consulta de todos los elementos del mes
//Devuelve una lista que contiene los elementos del mes a consultar conforme al mes y el año
//Cada elemento es una tupla del tipo (monto,conpecto,tipo,dia_del_mes)
Future<List> consultaElementosMes(String user, int year, int month) async {
  ///Devulve lista (monto,conpecto,tipo,dia_del_mes)

  //Lista de importancia
  List elementosDelMes = [];
  //Fecha
  DateTime fechaDown = DateTime(year = year, month = month);
  DateTime fechaUp = DateTime(year = year, month = month + 1);

  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("transactions");
  //consulta
  QuerySnapshot queryElementos = await collectionReference
      .where("fecha", isGreaterThanOrEqualTo: fechaDown)
      .where("fecha", isLessThan: fechaUp)
      .get();

  for (var document in queryElementos.docs) {
    elementosDelMes.add((
      document.get(FieldPath(const ['monto'])),
      document.get(FieldPath(const ['concepto'])),
      document.get(FieldPath(const ['tipo'])) == 1 ? "ingreso" : 'egreso',
      document.get(FieldPath(const ['fecha'])).toDate().day
    ));
  }
  return elementosDelMes;
}

Future<List> consultaP(String user, int year, int month) async {
  ///Devulve lista (monto,conpecto,tipo,dia_del_mes)

  //Mapa de elementos
  Map<int, num> mapa = {};
  //Lista de importancia
  List elementosDelMes = [];
  //Fecha
  DateTime fechaDown = DateTime(year = year, month = month);
  DateTime fechaUp = DateTime(year = year, month = month + 1);

  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("transactions");
  //consulta
  QuerySnapshot queryElementos = await collectionReference
      .where("fecha", isGreaterThanOrEqualTo: fechaDown)
      .where("fecha", isLessThan: fechaUp)
      .get();

  //Generamos toda la lista de puntos generales
  for (var document in queryElementos.docs) {
    var key = document.get(FieldPath(const ['fecha'])).toDate().day;
    var value = document.get(FieldPath(const ['monto']));
    if (mapa.containsKey(key)) {
      value = mapa[key]! + value;
    }
    mapa.addAll({key: value});
  }

  elementosDelMes = [for (var e in mapa.entries) (e.key, e.value)];
  return elementosDelMes;
}
