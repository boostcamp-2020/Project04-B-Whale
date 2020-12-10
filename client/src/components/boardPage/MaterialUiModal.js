/* eslint-disable react/jsx-props-no-spreading */
import React, { useContext, forwardRef } from 'react';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogTitle from '@material-ui/core/DialogTitle';
import Slide from '@material-ui/core/Slide';
import { deleteList } from '../../utils/listRequest';
import BoardDetailContext from '../../context/BoardDetailContext';

const Transition = forwardRef((props, ref) => {
    return <Slide direction="up" ref={ref} {...props} />;
});

export default function AlertDialogSlide({ open, setOpen, setListMenuState, listId }) {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);

    const handleDisagree = () => {
        setListMenuState(false);
    };

    const handleAgree = async () => {
        // 리스트 삭제 api
        const { status } = await deleteList({ listId });
        console.log(status);
        boardDetail.lists.splice(
            boardDetail.lists.findIndex((v) => {
                return v.id === listId;
            }),
            1,
        );
        // status switch
        setBoardDetail({ ...boardDetail });
        setListMenuState(false);
    };

    return (
        <div>
            <Dialog
                open={open}
                TransitionComponent={Transition}
                keepMounted
                onClose={() => setOpen(false)}
            >
                <DialogTitle>정말 삭제하시겠습니까?😥</DialogTitle>
                <DialogActions>
                    <Button onClick={handleDisagree} color="primary">
                        Disagree
                    </Button>
                    <Button onClick={handleAgree} color="primary">
                        Agree
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}
