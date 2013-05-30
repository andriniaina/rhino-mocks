using Castle.Core.Interceptor;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation.Actions
{
    ///<summary>
    ///</summary>
    public class InvokeProperty : IInvocationActionn
    {
        IMockedObject proxyInstance;
        MockRepository mockRepository;

        ///<summary>
        ///</summary>
        public InvokeProperty(IMockedObject proxy_instance, MockRepository mockRepository)
        {
            proxyInstance = proxy_instance;
            this.mockRepository = mockRepository;
        }

        ///<summary>
        ///</summary>
        public void PerformAgainst(IInvocation invocation)
        {
            invocation.ReturnValue = proxyInstance.HandleProperty(invocation.GetConcreteMethod(), invocation.Arguments);
            mockRepository.RegisterPropertyBehaviorOn(proxyInstance);
            return;
        }
    }
}