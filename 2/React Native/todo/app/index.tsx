import Title from "@/components/Title";
import { TextInput, ScrollView, Text, View, StyleSheet, StatusBar } from "react-native";
import { theme, styles } from '@/components/styles'
import SuperButton from "@/components/SuperButton";
import TodoItem, { ITodoItem } from "@/components/TodoItem";
import { useState, useEffect } from "react";
import * as SystemUI from 'expo-system-ui';

export default function Index() {
  const [newItem, setNewItem] = useState<string>("");
  const [todos, setTodos] = useState<Array<ITodoItem>>([])

  //quando inicia
  useEffect(() => {
    SystemUI.setBackgroundColorAsync(theme.background)
  }, [])

  const addTodo = () => {
    if (newItem.trim()) {
      const todoItem: ITodoItem = {
        id: Date.now(),
        name: newItem,
        completed: false
      }

      setTodos([...todos, todoItem])
      setNewItem("")
    }

  }

  const updateTodo = (id: number) => {
    setTodos((prevState: Array<ITodoItem>) => {
      return prevState.map((item) => {
        if (item.id === id) {
          return { ...item, completed: !item.completed }
        }

        return item;
      })
    })
  }

  const deleteTodo = (id: number) => {
    setTodos(prevState => {
      return prevState.filter(item => {
        if (item.id === id) {
          return false;
        }

        return true;
      })
    })
  }

  return (
    <ScrollView style={styles.container}>
      <StatusBar backgroundColor={theme.header}></StatusBar>
      <View style={styles.container}>
        <Title name="Adicione seu item:" ></Title>

        <TextInput
          value={newItem}
          onChangeText={setNewItem}
          style={styles.input}
          placeholderTextColor={theme.placeholderTextColor}
          placeholder="Digite seu novo item"
        />
        <SuperButton title="Adicionar" onPress={addTodo}></SuperButton>

        {todos.map((item) => {
          return <TodoItem
            key={item.id.toString()}
            todo={item}
            updateTodo={updateTodo}
            deleteTodo={deleteTodo} />
        })}


      </View>
    </ScrollView>
  );
}



