import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/team.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/group_entity.dart';

class TournamentLocalDatasource {
  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>> _loadData() async {
    if (_cachedData != null) return _cachedData!;
    final jsonString = await rootBundle.loadString('assets/data/tournament_2026.json');
    _cachedData = jsonDecode(jsonString) as Map<String, dynamic>;
    return _cachedData!;
  }

  Future<List<Team>> getTeams() async {
    final data = await _loadData();
    final list = data['teams'] as List<dynamic>;
    return list.map((t) => Team.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<List<GroupEntity>> getGroups() async {
    final data = await _loadData();
    final list = data['groups'] as List<dynamic>;
    return list.map((g) => GroupEntity.fromJson(g as Map<String, dynamic>)).toList();
  }

  Future<List<MatchEntity>> getMatches() async {
    final data = await _loadData();
    final list = data['matches'] as List<dynamic>;
    return list.map((m) => MatchEntity.fromJson(m as Map<String, dynamic>)).toList();
  }
}
