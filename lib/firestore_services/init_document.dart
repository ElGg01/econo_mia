import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitDocument {


  static User? createDocumentAfterSignUpWithEmailAndPassword(User? credential){

    final db = FirebaseFirestore.instance;

    //Inicialización de subcolección
    //Es una inicialización de campos vacios solo para que se genere el usuario sin campos
    final datos = <String, dynamic>{
      "expense": 0,
      "name": "assumption",
    };
    //Subcoleccion de ingresos
    //!!!!!!!!!!!!!!CAMBIAR EL USUARIO AL ACTIVO
    final refIngresos = db
        .collection('users')
        .doc(credential!.uid)
        .collection('assumption')
        .doc();
    refIngresos.set(datos);
    final refEgresos = db
        .collection('users')
        .doc(credential!.uid)
        .collection('transactions')
        .doc();

    // Datos a escribir
    Map<String, dynamic> new_datos = {
      'concepto': "apertura", // ID del documento
      'fecha': Timestamp.fromDate(DateTime.now()), // Número de gasto
      'monto': 100, // Nombre del gasto
      'categoria': 1
    };
    refEgresos.set(new_datos);

    //Generación de campo SALDO, este cambiara con cada ingreso y egreso
    final refUsuario = db.collection('users').doc(credential!.uid);
    refUsuario.set({"saldo": 0.0});

    return credential;
  }

  static Future<void> createDocumentAfterSignInWithGoogleProvider(User? credential) async {

    final db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> collectionRef = db.collection('users');
    bool response = await checkIfDocumentExists(collectionRef, credential);
    if (!response) return;
    else {
      final datos = <String, dynamic>{
        "expense": 0,
        "name": "assumption",
      };
      final refIngresos = db
          .collection('users')
          .doc(credential!.uid)
          .collection('assumption')
          .doc();
      await refIngresos.set(datos);
      final refEgresos = db
          .collection('users')
          .doc(credential!.uid)
          .collection('transactions')
          .doc();

      Map<String, dynamic> new_datos = {
        'concepto': "apertura",
        'fecha': Timestamp.fromDate(DateTime.now()),
        'monto': 100,
        'categoria': 1
      };
      await refEgresos.set(new_datos);

      final refUsuario = db.collection('users').doc(credential!.uid);
      await refUsuario.set({"saldo": 0.0});
    }

  }

  static Future<bool> checkIfDocumentExists(CollectionReference<Map<String, dynamic>> collectionReference, User? user) async{
    DocumentSnapshot<Map<String, dynamic>> doc = await collectionReference.doc(user!.uid).get();
    return doc.exists;
  }
}