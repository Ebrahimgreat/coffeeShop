import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
class account extends StatefulWidget {
      const account({super.key});

      @override
      State<account> createState() => _accountState();
    }

    class _accountState extends State<account> {

      final _userNameController = TextEditingController();
      final _addressController=TextEditingController();
      final _bioController=TextEditingController();
      final supabase = Supabase.instance.client;
      bool _loading = true;

      Future<void> _getProfile() async {
        setState(() {
          _loading = true;
        });
        try {
          final userId = supabase.auth.currentSession!.user.id;
          print(userId);
          final data = await supabase.from('UserProfile').select()
              .eq('user_id', userId).select().single();
          _userNameController.text = (data['name'] ?? ' ') as String;
          _bioController.text=(data['bio']?? '') as String;
          _addressController.text=(data['address']?? '') as String;
          print(data);
        }
        on PostgrestException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message))
          );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error'))
          );
        }
        finally {
          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        }
      }

      void logout() async{
        supabase.auth.signOut();
        if(mounted){
          Navigator.pushNamed(context,'/signin');
        }

      }

      Future<void> _updateProfile() async {
        setState(() {
          _loading = true;
        });
        final userName = _userNameController;
        final user = supabase.auth.currentUser;
        final updates = {
          'id': user!.id,
          'username': userName,

        };
        try {
          await supabase.from('userProfile').upsert(updates);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('successfuly Updated')));
          }
        } on PostgrestException catch (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.message)));
          }
        }
      }
        @override
        void initState() {
          super.initState();
          _getProfile();
        }
        @override
        void dispose() {
          _userNameController.dispose();
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                      labelText: 'Name '
                  ),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Address'
                  ),
                ),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                      labelText: 'bio '
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(onPressed: _loading ? null : _updateProfile,
                  child: Text(_loading ? 'Saving...' : 'Update'),),
                MaterialButton(onPressed: (){
                  logout();
                },child:Text('Logout'),)
              ],

            ),
          );
        }

    }