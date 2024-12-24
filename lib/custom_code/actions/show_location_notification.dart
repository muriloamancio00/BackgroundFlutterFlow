// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
Timer? locationTimer;

// Função para exibir a notificação e atualizar a localização
Future<void> showLocationNotification() async {
  try {
    // Criar o canal de notificação para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'location_channel', // ID do canal
      'Localização em Background', // Nome do canal
      description: 'Serviço ativo coletando dados de localização.', // Descrição
      importance: Importance.high, // Importância da notificação
    );

    // Criar o canal, se ainda não existir
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Obter a localização atual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Configurar a notificação com a nova localização
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'location_channel', // ID do canal
      'Localização em Background', // Título da notificação
      channelDescription: 'Coletando dados de localização.', // Descrição
      importance: Importance.high, // Importância da notificação
      priority: Priority.high, // Prioridade
      ongoing: true, // Manter a notificação persistente
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Exibir a notificação
    await notificationsPlugin.show(
      0, // ID da notificação
      'Localização Atualizada', // Título
      'Lat: ${position.latitude}, Long: ${position.longitude}', // Conteúdo
      notificationDetails,
    );

    // Atualizar o AppState com a localização atual
    // Adapte conforme a estrutura do seu AppState
    // Exemplo:
    List<LatLng> latLngList = FFAppState().latLngList ?? [];
    latLngList.add(LatLng(position.latitude, position.longitude));
    FFAppState().latLngList = latLngList;

    print(
        'Localização salva: Lat ${position.latitude}, Long ${position.longitude}');
  } catch (e) {
    print('Erro ao obter localização: $e');
  }
}

// Função para iniciar o serviço de localização
void startLocationUpdates() async {
  // Solicitar permissões necessárias
  await requestPermissions();

  // Verificar se o serviço já está ativo
  if (locationTimer != null) {
    print('Serviço de localização já está ativo.');
    return;
  }

  // Configurar o Timer para executar a cada 10 segundos
  locationTimer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
    await showLocationNotification();
  });

  print('Serviço de localização iniciado.');
}

// Função opcional para parar o serviço de localização
void stopLocationUpdates() {
  if (locationTimer != null) {
    locationTimer?.cancel();
    locationTimer = null;
    print('Serviço de localização parado.');
  }
}

// Função para solicitar permissões de localização
Future<void> requestPermissions() async {
  // Solicitar permissão para localização
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      // Exibir alerta ou outra ação se a permissão não for concedida
      print('Permissão de localização não concedida.');
    }
  }

  // Solicitar permissão para localização em segundo plano
  var backgroundStatus = await Permission.locationAlways.status;
  if (!backgroundStatus.isGranted) {
    backgroundStatus = await Permission.locationAlways.request();
    if (!backgroundStatus.isGranted) {
      // Exibir alerta ou outra ação se a permissão não for concedida
      print('Permissão de localização em segundo plano não concedida.');
    }
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
