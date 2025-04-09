
import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/models/person/relationship.dart';

class RelationshipService {
  static void establishFamilyRelations(Character parent, Character child) {
    parent.children.add(child);
    child.parents.add(parent);

    parent.relationships.add(Relationship(
      id: 'rel_${parent.id}_${child.id}',
      characterId: parent.id,
      targetId: child.id,
      type: RelationshipType.parent,
    ));

    child.relationships.add(Relationship(
      id: 'rel_${child.id}_${parent.id}',
      characterId: child.id,
      targetId: parent.id,
      type: RelationshipType.child,
    ));
  }
}