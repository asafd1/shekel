class FamilyNotFoundException implements Exception{
  final String familyId;
  FamilyNotFoundException(this.familyId);
}