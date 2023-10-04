class DegreeRelations {
  DegreeRelations ({required this.degreeRelations});

  Map<String,List<String>> degreeRelations = {
    "ALL": ["ISIS", "IELE", "MATE", "ADMIN", "IIND", "ARQUI", "ARTE", "DISE", "DERE", "HIST"],
    "ISIS": ["ISIS", "IELE", "MATE", "ADMIN", "IIND"],
    "IELE": ["ISIS", "IELE", "MATE"],
    "MATE": ["ISIS", "MATE", "ADMIN", "IIND"],
    "ADMIN": ["ADMIN", "IIND", "DERE"],
    "IIND": ["ISIS", "IELE", "MATE", "ADMIN", "IIND"],
    "ARQUI": ["ARQUI", "ARTE", "DISE"],
    "ARTE": ["ARQUI", "ARTE", "DISE"],
    "DISE": ["ARQUI", "ARTE", "DISE"],
    "DERE": ["ADMIN", "DERE", "HIST"],
    "HIST": ["DERE", "HIST"]
  };
}




