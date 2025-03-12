import { Alert, TouchableOpacity, Text, StyleSheet } from 'react-native'
import { theme } from './styles';
import Ionicons from '@expo/vector-icons/Ionicons';

export interface ITodoItem {
    id: number,
    name: string,
    completed: boolean,
}

interface ITodoItemProps {
    todo: ITodoItem,
    updateTodo: (id: number) => void
    deleteTodo: (id: number) => void
}

const TodoItem = ({ todo, updateTodo, deleteTodo }: ITodoItemProps) => {
    const { id, name, completed } = todo;
    const handleUpdate = () => {
        updateTodo(id)
    }

    const handleDelete = () => {
        Alert.alert("Apagar item", "Tem certeza ?", [
            { text: "Não" },
            {
                text: "Sim",
                onPress: () => { deleteTodo(id) }
            }
        ])
    }

    return (
        <TouchableOpacity style={styles.container} onPress={handleUpdate} onLongPress={handleDelete} >
            <Text style={styles.text}>{name}</Text>
            <Ionicons name={completed ? "bookmark" : "bookmark-outline"} size={24} color={theme.tint} />
        </TouchableOpacity>
    )
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        backgroundColor: theme.placeholderTextColor,
        width: '100%',
        height: 40,
        marginBottom: 16,
        borderRadius: 8,
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingHorizontal: 16
    },
    text: {
        color: '#AAA'
    }
})



export default TodoItem;