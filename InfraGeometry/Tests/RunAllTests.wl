$pacletDir = DirectoryName[DirectoryName[$InputFileName]];

PacletDirectoryLoad[$pacletDir];
Needs["WolframInstitute`InfraGeometry`"];

$testDir = DirectoryName[$InputFileName];


(* Every .wlt in this directory and its category subfolders, discovered rather than listed: the hand-kept
   list had gone stale in both directions -- five test files unrun, four named
   files gone. *)

Scan[
  file |-> ( Print["Running ", FileBaseName[file], "..."]; Print[TestReport[file]] ),
  FileNames["*.wlt", $testDir, Infinity]
]
