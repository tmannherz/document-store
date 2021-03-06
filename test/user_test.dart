import 'package:test/test.dart';
import '../lib/user.dart';
import 'helper.dart';

main() async {
    await initTestConfig();

    test('Constructors, getters and setters', () {
        var user = new User('abcdef');
        expect(user.id, equals('abcdef'));

        Map data = {
            'id': 'bogus',
            'username': 'test_user',
            'password_hash': 'hash12345790',
            'is_active': true
        };
        user.fromMap(data);
        expect(user.id, isNot('bogus'));
        data['id'] = 'abcdef';
        expect(user.toMap(), equals(data));
    });

    test('Save, load and delete cycle', () async {
        await new User().deleteByUsername('test_user');
        // save
        var user = new User()
            ..username = 'test_user'
            ..passwordHash = 'hash12345790'
            ..isActive = false;
        var saveResult = await user.save();
        expect(saveResult, isTrue);
        expect(user.isActive, isFalse);
        expect(user.created, isNotNull);
        expect(user.created.day, new DateTime.now().day);
        var newId = user.id;

        // load
        user = new User(newId);
        var loadResult = await user.load();
        expect(loadResult, isTrue);
        expect(user.username, equals('test_user'));
        expect(user.passwordHash, equals('hash12345790'));

        // delete
        expect(await user.delete(), isTrue);
    });

    test('Register user', () async {
        await new User().deleteByUsername('reg_user');
        String username = 'reg_user';
        User user = new User();
        String id = await user.register(username, 'secret');
        expect(id, isNotNull);
        expect(user.isActive, isTrue);
        bool res = await user.load(id);
        expect(res, isTrue);
    });

    test('Load and delete by username', () async {
        await new User().deleteByUsername('load_user');
        String username = 'load_user';
        User user = new User()
            ..username = username
            ..password = 'secret';

        bool res = await user.loadByUsername(username);
        expect(res, isFalse);
        await user.save();
        res = await user.loadByUsername(username);
        expect(res, isTrue);
        res = await user.deleteByUsername(username);
        expect(res, isTrue);
    });

    test('Password hashing and authentication', () async {
        String username = 'auth_user';
        User user = new User();
        await user.deleteByUsername(username);
        user..username = username
            ..password = 'secret';

        user.toMap();  // hashes pw
        expect(user.passwordHash, isNotNull);
        expect(await user.authenticate(username, 'secret'), isFalse);  // user doesn't exist yet
        await user.save();
        expect(await user.authenticate(username, 'secret'), isTrue);
        expect(await user.authenticate(username, 'badpw'), isFalse);
        expect(await user.authenticate('bad_user', 'secret'), isFalse);
        user.isActive = false;
        await user.save();
        expect(await user.authenticate(username, 'secret'), isFalse);  // not active
    });
}