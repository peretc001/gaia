import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: SvgPicture.asset('assets/svg/cloud.svg', height: 25, width: 25),
      trailing: Icon(Icons.arrow_forward_ios),
      title: Text('Heading', style: theme.textTheme.bodyMedium),
      subtitle: Text('subtitle', style: theme.textTheme.bodySmall),
      onTap: () {
        Navigator.of(context).pushNamed('/page', arguments: 'bbb');
      },
    );
  }
}
