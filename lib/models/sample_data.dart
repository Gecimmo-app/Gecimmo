import 'package:flutter/material.dart';
import 'task.dart';

List<Task> appTasks = [
  Task(id: '1', title: 'Rendez-vous client - Entreprise Alpha', type: TaskType.rendezvous,
    status: TaskStatus.aVenir, date: DateTime(2026, 4, 8), time: '14:30',
    location: 'Paris, France', assignee: 'Marie Dubois',
    project: 'Projet Alpha', notes: 'Préparer la présentation des nouvelles offres.'),
  Task(id: '2', title: 'Rappel - Suivi opportunité Beta', type: TaskType.rappel,
    status: TaskStatus.realisees, date: DateTime(2026, 4, 7), time: '10:00',
    location: 'Téléphone', assignee: 'Pierre Martin',
    project: 'Projet Beta', notes: 'Relancer le client sur la proposition envoyée.'),
  Task(id: '3', title: 'Opportunité - Nouveau prospect', type: TaskType.opportunite,
    status: TaskStatus.depassees, date: DateTime(2026, 4, 5), time: '09:00',
    location: 'Lyon, France', assignee: 'Sophie Laurent',
    project: 'Prospection', notes: 'Premier contact avec le prospect.'),
  Task(id: '4', title: 'Report - Réunion équipe commerciale', type: TaskType.report,
    status: TaskStatus.annulees, date: DateTime(2026, 4, 10), time: '11:00',
    location: 'Siège social', assignee: 'Marie Dubois', project: 'Interne', notes: 'Reporté au 20/04.'),
  Task(id: '5', title: 'Rendez-vous - Démo produit TechCorp', type: TaskType.rendezvous,
    status: TaskStatus.aVenir, date: DateTime(2026, 4, 14), time: '15:00',
    location: 'Visio Teams', assignee: 'Pierre Martin', project: 'TechCorp', notes: 'Démonstration v3.'),
  Task(id: '6', title: 'Rappel - Signature contrat Gamma', type: TaskType.rappel,
    status: TaskStatus.aVenir, date: DateTime(2026, 4, 16), time: '09:30',
    location: 'Bordeaux, France', assignee: 'Sophie Laurent', project: 'Projet Gamma', notes: '2 exemplaires.'),
];

final List<Contact> appContacts = [
  Contact(id: 'c1', name: 'Marie Dubois', email: 'marie.dubois@alpha.fr', phone: '+33 6 12 34 56 78',
    company: 'Entreprise Alpha', role: 'Directrice Commerciale', avatarColor: Color(0xFF16A34A)),
  Contact(id: 'c2', name: 'Pierre Martin', email: 'p.martin@beta.com', phone: '+33 6 98 76 54 32',
    company: 'Beta Solutions', role: 'Responsable Achat', avatarColor: Color(0xFF16A34A)),
  Contact(id: 'c3', name: 'Sophie Laurent', email: 'sophie@prospect.io', phone: '+33 7 11 22 33 44',
    company: 'Nouveau Prospect SARL', role: 'PDG', avatarColor: Color(0xFF7C3AED)),
  Contact(id: 'c4', name: 'Thomas Remy', email: 't.remy@techcorp.eu', phone: '+33 6 55 44 33 22',
    company: 'TechCorp Europe', role: 'CTO', avatarColor: Color(0xFFEA580C)),
  Contact(id: 'c5', name: 'Clara Fontaine', email: 'clara@gamma.fr', phone: '+33 6 77 88 99 00',
    company: 'Gamma Industrie', role: 'Directrice Générale', avatarColor: Color(0xFFDC2626)),
];

final List<Project> appProjects = [
  Project(id: 'p1', name: 'Projet Alpha', client: 'Entreprise Alpha', progress: 0.72, color: Color(0xFF2563EB), taskCount: 8, status: 'En cours'),
  Project(id: 'p2', name: 'Projet Beta', client: 'Beta Solutions', progress: 0.45, color: Color(0xFF16A34A), taskCount: 5, status: 'En cours'),
  Project(id: 'p3', name: 'Projet Gamma', client: 'Gamma Industrie', progress: 0.90, color: Color(0xFF9333EA), taskCount: 12, status: 'Presque terminé'),
  Project(id: 'p4', name: 'TechCorp Demo', client: 'TechCorp Europe', progress: 0.20, color: Color(0xFFEA580C), taskCount: 3, status: 'Démarrage'),
  Project(id: 'p5', name: 'Prospection Q2', client: 'Divers', progress: 0.55, color: Color(0xFF64748B), taskCount: 6, status: 'En cours'),
];

final List<AppNotification> appNotifications = [
  AppNotification(id: 'n1', title: 'Rendez-vous dans 1 heure', body: 'Rendez-vous client - Entreprise Alpha à 14:30',
    time: DateTime(2026, 4, 8, 13, 30), read: false, icon: Icons.calendar_today, color: Color(0xFF16A34A)),
  AppNotification(id: 'n2', title: 'Tâche dépassée', body: 'Opportunité - Nouveau prospect était prévue le 05/04',
    time: DateTime(2026, 4, 6, 9, 0), read: false, icon: Icons.warning_amber, color: Color(0xFFDC2626)),
  AppNotification(id: 'n3', title: 'Tâche réalisée', body: 'Rappel - Suivi opportunité Beta marqué comme réalisé',
    time: DateTime(2026, 4, 7, 10, 15), read: true, icon: Icons.check_circle, color: Color(0xFF16A34A)),
  AppNotification(id: 'n4', title: 'Nouveau projet assigné', body: 'Vous êtes assigné au projet TechCorp Demo',
    time: DateTime(2026, 4, 6, 14, 0), read: true, icon: Icons.folder_open, color: Color(0xFFEA580C)),
  AppNotification(id: 'n5', title: 'Rappel demain', body: 'Rendez-vous - Démo produit TechCorp à 15:00',
    time: DateTime(2026, 4, 13, 18, 0), read: false, icon: Icons.notifications_active, color: Color(0xFF7C3AED)),
];

const List<String> projets     = ['Projet Alpha', 'Projet Beta', 'Projet Gamma', 'TechCorp Demo', 'Prospection Q2'];
const List<String> commerciaux = ['Marie Dubois', 'Pierre Martin', 'Sophie Laurent', 'Thomas Remy'];
const List<String> tcs         = ['TC Paris', 'TC Lyon', 'TC Bordeaux', 'TC Marseille'];
const List<String> motifs      = ['Prospection', 'Suivi client', 'Négociation', 'Clôture', 'Support'];

Map<int, List<String>> getTaskDotsByMonth(int year, int month) {
  final result = <int, List<String>>{};
  for (final t in appTasks) {
    if (t.date.year == year && t.date.month == month) {
      result.putIfAbsent(t.date.day, () => []).add(t.id);
    }
  }
  return result;
}