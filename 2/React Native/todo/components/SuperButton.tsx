import { TouchableOpacity, Text, StyleSheet } from 'react-native'
import Ionicons from '@expo/vector-icons/Ionicons';

interface ISuperButton {
    title: string,
    icon?: keyof typeof Ionicons.glyphMap
    onPress: () => void
}

const SuperButton = (props: ISuperButton) => {
    const { title, icon, onPress } = props;
    return (
        <TouchableOpacity style={styles.container} onPress={props.onPress}>
            {icon && <Ionicons name={icon} size={32} color="white" />}
            <Text style={styles.text}>{props.title}</Text>
        </TouchableOpacity>
    )
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        width: '100%',
        height: 50,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'purple',
        marginVertical: 16,
        borderRadius: 25,
    },
    text: {
        marginLeft: 8,
        color: 'white',
        fontSize: 18,
        fontWeight: 'bold'
    }
})

export default SuperButton;