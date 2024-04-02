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
  final datos = <String, dynamic>{
    "monto": 0,
    "fecha": DateTime.now(),
  };
  //Subcoleccion de ingresos
  //!!!!!!!!!!!!!!CAMBIAR EL USUARIO AL ACTIVO
  final refIngresos =
      db.collection('users').doc(user).collection('ingresos').doc();
  //Generación de subcoleccion de ingresos
  refIngresos.set(datos);
  //Subcoleccion de egresos
  //!!!!!!!!!!!!!!CAMBIAR EL USUARIO AL ACTIVO
  final refEgresos =
      db.collection('users').doc(user).collection('egresos').doc();
  //Generación de subcoleccion de ingresos
  refEgresos.set(datos);

  //Generación de campo SALDO, este cambiara con cada ingreso y egreso
  final refUsuario = db.collection('users').doc(user);
  refUsuario.set({"saldo": 0});
}

//------------------------Agregar Ingreso-----------------------------------
Future<void> addIngreso(double monto, String user) async {
  //Agrega un ingreso conforme al monto y el identificador en String del usuario actual
  //así como atualizar el cambo saldo del usuario
  final transaccion = {
    "monto": monto,
    "fecha": DateTime.now(),
  };
  //Demo es el usuario cambialo por el user de autentication
  db.collection("users").doc(user).collection('ingresos').add(transaccion);
  //Actualizamos el saldo
  db.collection("users").doc(user).update(
    {"saldo": FieldValue.increment(monto)},
  );
}
//------------------------Agregar Egreso-----------------------------------

Future<void> addEgreso(double monto, String user) async {
  final transaccion = {
    "monto": monto,
    "fecha": DateTime.now(),
  };
  //Demo es el usuario cambialo por el user de autentication
  db.collection("users").doc(user).collection('egresos').add(transaccion);
  //Actualizamos el saldo
  //Parceamos
  db.collection("users").doc(user).update(
    {"saldo": FieldValue.increment(-monto)},
  );
}

//------------------------Consultas-----------------------------------
//Consulta ingresos desde siempre
//Utiliza el identificador del usuario como String
//Lista que contiene elementos  de todos los ingresos realizados por el usuario
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaIngresosSiempre(String user) async {
  //Lista de importancia
  List ingresosSiempre = [];
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("ingresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference.get();

  for (var document in queryIngresos.docs) {
    ingresosSiempre.add(document.data());
  }
  return ingresosSiempre;
}

//Consulta egresos desde siempre
//Lista que contiene elementos  de todos los egresos realizados por el usuario
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaEgresosSiempre(String user) async {
  //Lista de importancia
  List egresosSiempre = [];
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("egresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference.get();

  for (var document in queryIngresos.docs) {
    egresosSiempre.add(document.data());
  }
  return egresosSiempre;
}

//Consulta de Ingresos totales del usuario en todo el tiempo
//Es una lista devuelve la suma de todos los ingresos exitentes en
//la subcoleccion de ingresos
//Si puedes cambiarlo a un solo double, mejor.
Future<List> consultaIngresosTotales(String user) async {
  List monto = [];
  //Cambia el usuario demo por el usuario actual
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("ingresos");

  AggregateQuerySnapshot aggregateQuerySnapshotSum =
      await collectionReference.aggregate(sum('monto')).get();
  monto.add(aggregateQuerySnapshotSum.getSum('monto'));
  return monto;
}

//Consulta de Ingresos totales del usuario en todo el tiempo
//Es una lista devuelve la suma de todos los ingresos exitentes en
//la subcoleccion de ingresos
//Si puedes cambiarlo a un solo double, mejor.
Future<List> consultaEgresosTotales(String user) async {
  List monto = [];
  //Cambia el usuario demo por el usuario actual
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("egresos");

  AggregateQuerySnapshot aggregateQuerySnapshotSum =
      await collectionReference.aggregate(sum('monto')).get();
  monto.add(aggregateQuerySnapshotSum.getSum('monto'));
  return monto;
}

//Consulta Ingresos del dia
//Lista que contiene elementos  de todos los ingresos realizados por el usuario
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaIngresosDelDia(String user) async {
  //Lista de importancia
  List ingresosDelDia = [];
  DateTime dia =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("ingresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: dia)
      .get();

  for (var document in queryIngresos.docs) {
    ingresosDelDia.add(document.data());
  }
  return ingresosDelDia;
}

//Consulta Egresos del dia
//Lista que contiene elementos  de todos los egresos realizados por el usuario
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaEgresosDelDia(String user) async {
  //Lista de importancia
  List egresosDelDia = [];
  DateTime dia =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("egresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: dia)
      .get();

  for (var document in queryIngresos.docs) {
    egresosDelDia.add(document.data());
  }
  return egresosDelDia;
}

//Consulta Egresos del mes
//Lista que contiene elementos  de todos los egresos realizados por el usuario durante el mes
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaEgresosDelMes(String user) async {
  //Lista de importancia
  List egresosDelMes = [];
  DateTime mes = DateTime(DateTime.now().year, DateTime.now().month);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("egresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: mes)
      .get();

  for (var document in queryIngresos.docs) {
    egresosDelMes.add(document.data());
  }
  return egresosDelMes;
}

//Consulta Ingresos del mes
//Lista que contiene elementos  de todos los egresos realizados por el usuario durante el mes
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaIngresosDelMes(String user) async {
  //Lista de importancia
  List ingresosDelMes = [];
  DateTime mes = DateTime(DateTime.now().year, DateTime.now().month);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("ingresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: mes)
      .get();

  for (var document in queryIngresos.docs) {
    ingresosDelMes.add(document.data());
  }
  return ingresosDelMes;
}

//Consulta Ingresos del año
//Lista que contiene elementos  de todos los egresos realizados por el usuario durante el año
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaIngresosDelyear(String user) async {
  //Lista de importancia
  List ingresosDelMes = [];
  DateTime ano = DateTime(DateTime.now().year);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("ingresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: ano)
      .get();

  for (var document in queryIngresos.docs) {
    ingresosDelMes.add(document.data());
  }
  return ingresosDelMes;
}

//Consulta Ingresos del año
//Lista que contiene elementos  de todos los egresos realizados por el usuario durante el año
//La Date esta como un DateTime así que al momento de usarlo cortalo a conveniencia
Future<List> consultaEgresosDelyear(String user) async {
  //Lista de importancia
  List egresosDelMes = [];
  DateTime ano = DateTime(DateTime.now().year);
  //Refrencia a la colección
  CollectionReference collectionReference =
      db.collection('users').doc(user).collection("egresos");
  //consulta
  QuerySnapshot queryIngresos = await collectionReference
      .where('fecha', isGreaterThanOrEqualTo: ano)
      .get();

  for (var document in queryIngresos.docs) {
    egresosDelMes.add(document.data());
  }
  return egresosDelMes;
}
