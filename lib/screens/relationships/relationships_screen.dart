import '../../models/person/character.dart';
import '../../models/pet.dart';
import '../../models/person/relationship.dart';
import '../../models/asset/assets.dart';
import '../../screens/main_game_screen.dart';
import 'package:flutter/material.dart';


class RelationshipsScreen extends StatefulWidget {
  final Character character;
  
  const RelationshipsScreen({Key? key, required this.character}) : super(key: key);
  
  @override
  _RelationshipsScreenState createState() => _RelationshipsScreenState();
}

class _RelationshipsScreenState extends State<RelationshipsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relations'),
        backgroundColor: const Color(0xFF0D47A1),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Famille'),
            Tab(text: 'Amis'),
            Tab(text: 'Partenaires'),
            Tab(text: 'Travail'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFamilyTab(),
          _buildFriendsTab(),
          _buildPartnersTab(),
          _buildWorkTab(),
        ],
      ),
    );
  }
  
  Widget _buildFamilyTab() {
    return ListView(
      children: [
        _buildSectionTitle('Parents'),
        ...widget.character.parents.map(_buildFamilyMemberTile),
        
        _buildSectionTitle('Frères et sœurs'),
        ...widget.character.siblings.map(_buildFamilyMemberTile),
        
        _buildSectionTitle('Enfants'),
        ...widget.character.children.map(_buildFamilyMemberTile),
        
        _buildSectionTitle('Animaux de compagnie'),
        ...widget.character.pets.map(_buildPetTile),
      ],
    );
  }
  
  Widget _buildFriendsTab() {
    final friends = widget.character.relationships.where(
      (r) => r.type == RelationshipType.friend
    ).toList();
    
    return friends.isEmpty
      ? const Center(child: Text('Pas d\'amis pour le moment'))
      : ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final relationship = friends[index];
            return _buildRelationshipTile(relationship);
          },
        );
  }
  
  Widget _buildPartnersTab() {
    final partners = widget.character.relationships.where(
      (r) => r.type == RelationshipType.spouse || r.type == RelationshipType.lover
    ).toList();
    
    return partners.isEmpty
      ? const Center(child: Text('Pas de partenaires pour le moment'))
      : ListView.builder(
          itemCount: partners.length,
          itemBuilder: (context, index) {
            final relationship = partners[index];
            return _buildRelationshipTile(relationship);
          },
        );
  }
  
  Widget _buildWorkTab() {
    final colleagues = widget.character.relationships.where(
      (r) => r.type == RelationshipType.colleague || r.type == RelationshipType.boss
    ).toList();
    
    return colleagues.isEmpty
      ? const Center(child: Text('Pas de collègues pour le moment'))
      : ListView.builder(
          itemCount: colleagues.length,
          itemBuilder: (context, index) {
            final relationship = colleagues[index];
            return _buildRelationshipTile(relationship);
          },
        );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }
  
  Widget _buildFamilyMemberTile(Character relative) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Icon(_getRelativeIcon(relative)),
      ),
      title: Text(relative.fullName),
      subtitle: Text('${relative.age} ans - ${relative.currentTitle}'),
      trailing: IconButton(
        icon: const Icon(Icons.chat_bubble_outline),
        onPressed: () => _showInteractionOptions(relative),
      ),
      onTap: () => _showRelativeDetails(relative),
    );
  }
  
  Widget _buildPetTile(Pet pet) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Icon(_getPetIcon(pet)),
      ),
      title: Text(pet.name),
      subtitle: Text('${pet.age} ans - ${pet.species}'),
      trailing: IconButton(
        icon: const Icon(Icons.pets),
        onPressed: () => _showPetInteractionOptions(pet),
      ),
    );
  }
  
  Widget _buildRelationshipTile(Relationship relationship) {
    // Trouver le personnage cible
    final targetId = relationship.targetId;
    final target = _findCharacterById(targetId);
    
    if (target == null) return const SizedBox.shrink();
    
    // Déterminer la couleur en fonction du statut de la relation
    Color statusColor;
    switch (relationship.status) {
      case RelationshipStatus.excellent:
        statusColor = Colors.green;
        break;
      case RelationshipStatus.good:
        statusColor = Colors.lightGreen;
        break;
      case RelationshipStatus.neutral:
        statusColor = Colors.yellow;
        break;
      case RelationshipStatus.poor:
        statusColor = Colors.orange;
        break;
      case RelationshipStatus.hostile:
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(target.fullName[0]),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      title: Text(target.fullName),
      subtitle: Text(
        '${_getRelationshipTypeLabel(relationship.type)} - ${_getRelationshipStatusLabel(relationship.status)}'
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () => _showRelationshipInteractionOptions(relationship, target),
      ),
      onTap: () => _showRelationshipDetails(relationship, target),
    );
  }
  
  // Fonctions utilitaires pour les icônes et textes
  IconData _getRelativeIcon(Character relative) {
    if (widget.character.parents.contains(relative)) {
      return relative.gender == 'Homme' ? Icons.face : Icons.face_3;
    } else if (widget.character.siblings.contains(relative)) {
      return Icons.people_alt;
    } else if (widget.character.children.contains(relative)) {
      return Icons.child_care;
    }
    return Icons.person;
  }
  
  IconData _getPetIcon(Pet pet) {
    switch (pet.species.toLowerCase()) {
      case 'chien':
        return Icons.pets;
      case 'chat':
        return Icons.pest_control;
      default:
        return Icons.emoji_nature;
    }
  }
  
  String _getRelationshipTypeLabel(RelationshipType type) {
    switch (type) {
      case RelationshipType.parent: return 'Parent';
      case RelationshipType.child: return 'Enfant';
      case RelationshipType.sibling: return 'Frère/Sœur';
      case RelationshipType.spouse: return 'Conjoint';
      case RelationshipType.friend: return 'Ami';
      case RelationshipType.colleague: return 'Collègue';
      case RelationshipType.boss: return 'Patron';
      case RelationshipType.enemy: return 'Ennemi';
      case RelationshipType.exSpouse: return 'Ex-conjoint';
      case RelationshipType.lover: return 'Amant';
      default: return 'Inconnu';
    }
  }
  
  String _getRelationshipStatusLabel(RelationshipStatus status) {
    switch (status) {
      case RelationshipStatus.excellent: return 'Excellente';
      case RelationshipStatus.good: return 'Bonne';
      case RelationshipStatus.neutral: return 'Neutre';
      case RelationshipStatus.poor: return 'Mauvaise';
      case RelationshipStatus.hostile: return 'Hostile';
      case RelationshipStatus.estranged: return 'Éloignée';
      default: return 'Inconnue';
    }
  }
  
  Character? _findCharacterById(String id) {
    // Rechercher dans toutes les personnes connues
    final allCharacters = [
      ...widget.character.parents,
      ...widget.character.siblings,
      ...widget.character.children,
      ...widget.character.partners,
    ];
    
    return allCharacters.firstWhere(
      (character) => character.id == id,
      orElse: () => null as Character, // Cette ligne causera une erreur si aucun personnage n'est trouvé
    );
  }
  
  void _showInteractionOptions(Character relative) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Discuter'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour discuter
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Offrir un cadeau'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour offrir un cadeau
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Donner de l\'argent'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour donner de l'argent
                },
              ),
              if (_canSwitchTo(relative))
                ListTile(
                  leading: const Icon(Icons.switch_account),
                  title: const Text('Jouer ce personnage'),
                  onTap: () {
                    Navigator.pop(context);
                    _switchToCharacter(relative);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  
  bool _canSwitchTo(Character character) {
    // Vérifier si on peut jouer ce personnage (enfant adulte par exemple)
    return widget.character.children.contains(character) && character.age >= 18;
  }
  
  void _switchToCharacter(Character newCharacter) {
    // Logique pour changer de personnage
    setState(() {
      // Simuler un transfert d'héritage
      if (widget.character.isAlive) {
        widget.character.isAlive = false;
        widget.character.deathDate = DateTime.now();
        widget.character.deathCause = "A cédé le contrôle";
        widget.character.addLifeEvent("J'ai cédé le contrôle à ${newCharacter.fullName}");
      }
      
      // Transférer l'héritage
      double inheritanceAmount = widget.character.money * 0.7; // 70% héritage
      newCharacter.money += inheritanceAmount;
      newCharacter.addLifeEvent("J'ai pris le contrôle après ${widget.character.fullName} et hérité de \$${inheritanceAmount.toStringAsFixed(2)}");
      
      // Naviguer vers l'écran principal avec le nouveau personnage
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => MainGameScreen(character: newCharacter),
        ),
      );
    });
  }
  
  void _showPetInteractionOptions(Pet pet) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.pets),
                title: const Text('Caresser'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour caresser l'animal
                  setState(() {
                    widget.character.stats['happiness'] = (widget.character.stats['happiness']! + 2).clamp(0.0, 100.0);
                    widget.character.addLifeEvent("J'ai passé du temps avec ${pet.name}");
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.food_bank),
                title: const Text('Nourrir'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour nourrir l'animal
                },
              ),
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Soigner'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour soigner l'animal
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showRelationshipInteractionOptions(Relationship relationship, Character target) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Discuter'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour discuter
                  setState(() {
                    relationship.improve(0.05);
                    widget.character.addLifeEvent("J'ai eu une conversation agréable avec ${target.fullName}");
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Offrir un cadeau'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique pour offrir un cadeau
                },
              ),
              if (relationship.type == RelationshipType.friend)
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Proposer une relation amoureuse'),
                  onTap: () {
                    Navigator.pop(context);
                    // Logique pour changer de type de relation
                  },
                ),
              if (relationship.status == RelationshipStatus.hostile)
                ListTile(
                  leading: const Icon(Icons.healing),
                  title: const Text('Tenter de se réconcilier'),
                  onTap: () {
                    Navigator.pop(context);
                    // Logique pour tenter de se réconcilier
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  
  void _showRelativeDetails(Character relative) {
    // Afficher les détails du membre de la famille
  }
  
  void _showRelationshipDetails(Relationship relationship, Character target) {
    // Afficher les détails de la relation
  }
}
