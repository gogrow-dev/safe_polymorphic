# frozen_string_literal: true

RSpec.describe 'Safe Polymorphic Associations' do
  before do
    User.create(username: 'username')
    Publisher.create(name: 'Publisher')
    OtherThing.create
  end

  describe '#allowed_classes' do
    context 'when using classes' do
      context 'when the owner is a User' do
        it 'should be able to create a Book' do
          book = Book.create(title: 'Book', owner: User.first)
          expect(book.owner_type).to eq('User')
        end
      end

      context 'when the owner is a Publisher' do
        it 'should be able to create a Book' do
          book = Book.create(title: 'Book', owner: Publisher.first)
          expect(book.owner_type).to eq('Publisher')
        end
      end

      context 'when the owner is a OtherThing' do
        subject { Book.create(title: 'Book', owner: OtherThing.first) }

        it 'should not be able to create a Book' do
          expect(subject).to_not be_valid
        end

        it 'should have an error message' do
          subject.valid?
          expect(subject.errors[:owner_type]).to include('OtherThing is not an allowed class')
        end
      end
    end

    context 'when using strings or symbols' do
      context 'when the owner is a User' do
        it 'should be able to create a OtherThing' do
          other_thing = OtherThing.create(thing: User.first)
          expect(other_thing.thing_type).to eq('User')
        end
      end

      context 'when the owner is a Publisher' do
        it 'should be able to create a OtherThing' do
          other_thing = OtherThing.create(thing: Publisher.first)
          expect(other_thing.thing_type).to eq('Publisher')
        end
      end

      context 'when the owner is a Book' do
        before do
          Book.create(title: 'Book', owner: User.first)
        end

        subject { OtherThing.create(thing: Book.first) }

        it 'should not be able to create a OtherThing' do
          expect(subject).to_not be_valid
        end

        it 'should have an error message' do
          subject.valid?
          expect(subject.errors[:thing_type]).to include('Book is not an allowed class')
        end
      end
    end

    context 'when it is optional' do
      it 'should be able to create a OtherThing' do
        other_thing = OtherThing.create
        expect(other_thing.thing_type).to eq(nil)
      end
    end
  end

  describe '#allowed_types' do
    context 'when using classes' do
      it 'should return the allowed types' do
        expect(Book.owner_types).to match_array([User, Publisher])
      end
    end

    context 'when using strings or symbols' do
      it 'should return the allowed types' do
        expect(OtherThing.thing_types).to match_array([User, Publisher])
      end
    end
  end

  context 'with existing books' do
    let!(:user_book) { Book.create(title: 'User Book', owner: User.first) }
    let!(:publisher_book) { Book.create(title: 'Publisher Book', owner: Publisher.first) }

    describe '#finder_methods' do
      context 'when searching by class' do
        it 'should return the books with the given owner type count' do
          expect(Book.with_owner(User).count).to eq(1)
          expect(Book.with_owner(Publisher).count).to eq(1)
        end

        it 'should return the books with the given owner type' do
          expect(Book.with_owner(User).first).to eq(user_book)
          expect(Book.with_owner(Publisher).first).to eq(publisher_book)
        end
      end

      context 'when searching by string' do
        it 'should return the books with the given owner type count' do
          expect(Book.with_owner('User').count).to eq(1)
          expect(Book.with_owner('Publisher').count).to eq(1)
        end
      end

      context 'when searching by instance of class' do
        it 'should return the books with the given owner type count' do
          expect(Book.with_owner(User.first).count).to eq(1)
          expect(Book.with_owner(Publisher.first).count).to eq(1)
        end
      end
    end

    describe '#scopes' do
      it 'should return the books with the given owner type count' do
        expect(Book.with_owner_user.count).to eq(1)
        expect(Book.with_owner_publisher.count).to eq(1)
      end

      it 'should return the books with the given owner type' do
        expect(Book.with_owner_user.first).to eq(user_book)
        expect(Book.with_owner_publisher.first).to eq(publisher_book)
      end
    end

    describe '#instance_methods' do
      it 'should return true if the owner type is the given type' do
        expect(user_book.owner_type_user?).to be_truthy
        expect(publisher_book.owner_type_publisher?).to be_truthy
      end

      it 'should return false if the owner type is not the given type' do
        expect(user_book.owner_type_publisher?).to be_falsey
        expect(publisher_book.owner_type_user?).to be_falsey
      end
    end
  end

  context 'with existing other things' do
    let!(:user_other_thing) { OtherThing.create(thing: User.first) }
    let!(:publisher_other_thing) { OtherThing.create(thing: Publisher.first) }

    describe '#finder_methods' do
      context 'when searching by class' do
        it 'should return the other things with the given thing type count' do
          expect(OtherThing.with_thing(User).count).to eq(1)
          expect(OtherThing.with_thing(Publisher).count).to eq(1)
        end

        it 'should return the other things with the given thing type' do
          expect(OtherThing.with_thing(User).first).to eq(user_other_thing)
          expect(OtherThing.with_thing(Publisher).first).to eq(publisher_other_thing)
        end
      end

      context 'when searching by string' do
        it 'should return the other things with the given thing type count' do
          expect(OtherThing.with_thing('User').count).to eq(1)
          expect(OtherThing.with_thing('Publisher').count).to eq(1)
        end
      end

      context 'when searching by instance of class' do
        it 'should return the other things with the given thing type count' do
          expect(OtherThing.with_thing(User.first).count).to eq(1)
          expect(OtherThing.with_thing(Publisher.first).count).to eq(1)
        end
      end
    end

    describe '#scopes' do
      it 'should return the other things with the given thing type count' do
        expect(OtherThing.with_thing_user.count).to eq(1)
        expect(OtherThing.with_thing_publisher.count).to eq(1)
      end

      it 'should return the other things with the given thing type' do
        expect(OtherThing.with_thing_user.first).to eq(user_other_thing)
        expect(OtherThing.with_thing_publisher.first).to eq(publisher_other_thing)
      end
    end

    describe '#instance_methods' do
      it 'should return true if the thing type is the given type' do
        expect(user_other_thing.thing_type_user?).to be_truthy
        expect(publisher_other_thing.thing_type_publisher?).to be_truthy
      end

      it 'should return false if the thing type is not the given type' do
        expect(user_other_thing.thing_type_publisher?).to be_falsey
        expect(publisher_other_thing.thing_type_user?).to be_falsey
      end
    end
  end
end
