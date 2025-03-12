import { Text, StyleSheet } from 'react-native'
import { theme } from '@/components/styles';

interface ITitle {
    name: string,
    upperCase?: boolean;
}

/**
 * Criar um component bonitão de titulo
 * @param props que tem name que mostra o conteudo e upperCase pra deixar maisculo
 * @returns um View
 */

const Title = ({ name, upperCase }: ITitle) => {
    let value = name;
    if (upperCase) {
        value = name.toUpperCase()
    }

    return (
        <Text style={styles.title}>{value}</Text>
    )
}

const styles = StyleSheet.create({
    title: {
        fontSize: 16,
        fontWeight: 'bold',
        color: theme.tint
    }
})

export default Title;